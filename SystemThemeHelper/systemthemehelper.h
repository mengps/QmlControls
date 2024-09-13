#ifndef SYSTEMTHEMEHELPER_H
#define SYSTEMTHEMEHELPER_H

#include <QColor>
#include <QObject>

QT_FORWARD_DECLARE_CLASS(QWindow);

QT_FORWARD_DECLARE_CLASS(SystemThemeHelperPrivate);

class SystemThemeHelper : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QColor themeColor READ themeColor NOTIFY themeColorChanged)
    Q_PROPERTY(SystemThemeHelper::ColorScheme colorScheme READ colorScheme NOTIFY colorSchemeChanged)

public:
    enum class ColorScheme {
        None = 0,
        Dark = 1,
        Light = 2
    };
    Q_ENUM(ColorScheme);

    SystemThemeHelper(QObject *parent = nullptr);
    ~SystemThemeHelper();

    /**
     * @brief getThemeColor 立即获取当前主题颜色{不可用于绑定}
     * @warning 此接口更快，但不会自动更新
     * @return QColor
     */
    Q_INVOKABLE QColor getThemeColor() const;
    /**
     * @brief getColorScheme 立即获取当前颜色方案{不可用于绑定}
     * @warning 此接口更快，但不会自动更新
     * @return {@link SystemThemeHelper::ColorScheme}
     */
    Q_INVOKABLE SystemThemeHelper::ColorScheme getColorScheme() const;
    /**
     * @brief colorScheme 获取当前主题颜色{可用于绑定}
     * @return QColor
     */
    QColor themeColor();
    /**
     * @brief colorScheme 获取当前颜色方案{可用于绑定}
     * @return {@link SystemThemeHelper::ColorScheme}
     */
    SystemThemeHelper::ColorScheme colorScheme();

    Q_INVOKABLE static bool setWindowTitleBarMode(QWindow *window, bool isDark);

signals:
    void themeColorChanged();
    void colorSchemeChanged();

protected:
    virtual void timerEvent(QTimerEvent *);

private:
    Q_DECLARE_PRIVATE(SystemThemeHelper);
    QScopedPointer<SystemThemeHelperPrivate> d_ptr;
};


#endif // SYSTEMTHEMEHELPER_H
