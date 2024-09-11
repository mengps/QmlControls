#include "systemthemehelper.h"

#include <QBasicTimer>
#include <QWindow>
#include <QSettings>

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
    QColor m_themeColor;
    SystemThemeHelper::ColorScheme m_colorScheme = SystemThemeHelper::ColorScheme::None;

#ifdef Q_OS_WIN
    QBasicTimer m_timer;
    QSettings m_themeColorSettings { QSettings::UserScope, "Microsoft", "Windows\\DWM" };
    QSettings m_colorSchemeSettings { QSettings::UserScope, "Microsoft", "Windows\\CurrentVersion\\Themes\\Personalize" };
#endif
};

SystemThemeHelper::SystemThemeHelper(QObject *parent)
    : QObject{ parent }
    , d_ptr(new SystemThemeHelperPrivate)
{
    Q_D(SystemThemeHelper);

    d->m_themeColor = getThemeColor();
    d->m_colorScheme = getColorScheme();

#ifdef Q_OS_WIN
    d->m_timer.start(200, this);

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

QColor SystemThemeHelper::themeColor() const
{
    Q_D(const SystemThemeHelper);

    return d->m_themeColor;
}

SystemThemeHelper::ColorScheme SystemThemeHelper::colorScheme() const
{
    Q_D(const SystemThemeHelper);

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

void SystemThemeHelper::timerEvent(QTimerEvent *)
{
    Q_D(SystemThemeHelper);

    auto nowThemeColor = getThemeColor();
    if (nowThemeColor != d->m_themeColor) {
        d->m_themeColor = nowThemeColor;
        emit themeColorChanged();
    }

    auto nowColorScheme = getColorScheme() ;
    if (nowColorScheme != d->m_colorScheme) {
        d->m_colorScheme = nowColorScheme;
        emit colorSchemeChanged();
    }
}
