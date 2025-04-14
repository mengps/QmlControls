#ifndef DELEGATEUI_PLUGIN_H
#define DELEGATEUI_PLUGIN_H

#include <QQmlExtensionPlugin>

class DelegateUIPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)

public:
    void registerTypes(const char *uri) override;
};

#endif // DELEGATEUI_PLUGIN_H
