#include "systemthemehelper.h"

#include <QBasicTimer>
#include <QWindow>
#include <QSettings>

#ifdef QT_WIDGETS_LIB
#include <QWidget>
#endif //QT_WIDGETS_LIB

#if QT_VERSION >= QT_VERSION_CHECK(6, 5, 0)
#include <QGuiApplication>
#include <QStyleHints>
#endif

#ifdef Q_OS_WIN
#include <Windows.h>

typedef HRESULT (WINAPI *DwmSetWindowAttributeFunc)(HWND hwnd, DWORD dwAttribute, LPCVOID pvAttribute, DWORD cbAttribute);

static DwmSetWindowAttributeFunc pDwmSetWindowAttribute = nullptr;

static inline bool initializeFunctionPointers() {
    static bool initialized = false;
    if (!initialized) {
        HMODULE module = LoadLibraryW(L"dwmapi.dll");
        if (module) {
            if (!pDwmSetWindowAttribute) {
                pDwmSetWindowAttribute = reinterpret_cast<DwmSetWindowAttributeFunc>(
                    GetProcAddress(module, "DwmSetWindowAttribute"));
                if (!pDwmSetWindowAttribute) {
                    return false;
                }
            }

            initialized = true;
        }
    }

    return initialized;
}

#endif //Q_OS_WIN

class SystemThemeHelperPrivate
{
public:
    SystemThemeHelperPrivate(SystemThemeHelper *q) : q_ptr(q) { }

    Q_DECLARE_PUBLIC(SystemThemeHelper);

    void _updateThemeColor() {
        Q_Q(SystemThemeHelper);

        auto nowThemeColor = q->getThemeColor();
        if (nowThemeColor != m_themeColor) {
            m_themeColor = nowThemeColor;
            emit q->themeColorChanged();
        }
    }

    void _updateColorScheme() {
        Q_Q(SystemThemeHelper);

        auto nowColorScheme = q->getColorScheme() ;
        if (nowColorScheme != m_colorScheme) {
            m_colorScheme = nowColorScheme;
            emit q->colorSchemeChanged();
        }
    }

    SystemThemeHelper *q_ptr;
    QColor m_themeColor;
    SystemThemeHelper::ColorScheme m_colorScheme = SystemThemeHelper::ColorScheme::None;

    QBasicTimer m_timer;
#ifdef Q_OS_WIN
    QSettings m_themeColorSettings { QSettings::UserScope, "Microsoft", "Windows\\DWM" };
    QSettings m_colorSchemeSettings { QSettings::UserScope, "Microsoft", "Windows\\CurrentVersion\\Themes\\Personalize" };
#endif
};

SystemThemeHelper::SystemThemeHelper(QObject *parent)
    : QObject{ parent }
    , d_ptr(new SystemThemeHelperPrivate(this))
{
    Q_D(SystemThemeHelper);

    d->m_themeColor = getThemeColor();
    d->m_colorScheme = getColorScheme();

    d->m_timer.start(200, this);

#ifdef Q_OS_WIN
    initializeFunctionPointers();
#endif
}

SystemThemeHelper::~SystemThemeHelper()
{

}

QColor SystemThemeHelper::getThemeColor() const
{
    Q_D(const SystemThemeHelper);

#ifdef Q_OS_WIN
    return QColor::fromRgb(d->m_themeColorSettings.value("ColorizationColor").toUInt());
#endif
}

SystemThemeHelper::ColorScheme SystemThemeHelper::getColorScheme() const
{
    Q_D(const SystemThemeHelper);
#if QT_VERSION >= QT_VERSION_CHECK(6, 5, 0)
    const auto scheme = QGuiApplication::styleHints()->colorScheme();
    return scheme == Qt::ColorScheme::Dark ? ColorScheme::Dark : ColorScheme::Light;
#else
#ifdef Q_OS_WIN
    /*! 0：深色 - 1：浅色 */
    return !d->m_colorSchemeSettings.value("AppsUseLightTheme").toBool() ? ColorScheme::Dark : ColorScheme::Light;
#else //linux
    const QPalette defaultPalette;
    const auto text = defaultPalette.color(QPalette::WindowText);
    const auto window = defaultPalette.color(QPalette::Window);
    return text.lightness() > window.lightness() ? ColorScheme::Dark : ColorScheme::Light;
#endif // Q_OS_WIN
#endif // QT_VERSION
}

QColor SystemThemeHelper::themeColor()
{
    Q_D(SystemThemeHelper);

    d->_updateThemeColor();

    return d->m_themeColor;
}

SystemThemeHelper::ColorScheme SystemThemeHelper::colorScheme()
{
    Q_D(SystemThemeHelper);

    d->_updateColorScheme();

    return d->m_colorScheme;
}

bool SystemThemeHelper::setWindowTitleBarMode(QWindow *window, bool isDark)
{
#ifdef Q_OS_WIN
    return bool(pDwmSetWindowAttribute ? !pDwmSetWindowAttribute(HWND(window->winId()), 20, &isDark, sizeof(BOOL)) : false);
#else
    return false;
#endif //Q_OS_WIN
}

#ifdef QT_WIDGETS_LIB
bool SystemThemeHelper::setWindowTitleBarMode(QWidget *window, bool isDark)
{
#ifdef Q_OS_WIN
    return bool(pDwmSetWindowAttribute ? !pDwmSetWindowAttribute(HWND(window->winId()), 20, &isDark, sizeof(BOOL)) : false);
#else
    return false;
#endif //Q_OS_WIN
}
#endif //QT_WIDGETS_LIB

void SystemThemeHelper::timerEvent(QTimerEvent *)
{
    Q_D(SystemThemeHelper);

    d->_updateThemeColor();
}
