#include "delegateuiplugin.h"

#include <delapi.h>
#include <delapp.h>
#include <delasynchasher.h>
#include <delcolorgenerator.h>
#include <deliconfont.h>
#include <delrectangle.h>
#include <delsizegenerator.h>
#include <delsystemthemehelper.h>
#include <deltheme.h>
#include <delthemefunctions.h>
#include <delwatermark.h>
#include <delwindowagent.h>
#include <qqml.h>

void DelegateUIPlugin::registerTypes(const char *uri)
{
    // @uri DelegateUI
    qmlRegisterType<DelPen>(uri, 1, 0, "DelPen");
    qmlRegisterType<DelRectangle>(uri, 1, 0, "DelRectangle");
    qmlRegisterType<DelAsyncHasher>(uri, 1, 0, "DelAsyncHasher");
    qmlRegisterType<DelColorGenerator>(uri, 1, 0, "DelColorGenerator");
    qmlRegisterType<DelSizeGenerator>(uri, 1, 0, "DelSizeGenerator");
    qmlRegisterType<DelSystemThemeHelper>(uri, 1, 0, "DelSystemThemeHelper");
    qmlRegisterType<DelWatermark>(uri, 1, 0, "DelWatermark");
    qmlRegisterType<DelWindowAgent>(uri, 1, 0, "DelWindowAgent");

    qmlRegisterSingletonType<DelIcon>(uri, 1, 0, "DelIcon", &DelIcon::create);
    qmlRegisterSingletonType<DelApi>(uri, 1, 0, "DelApi", &DelApi::create);
    qmlRegisterSingletonType<DelApp>(uri, 1, 0, "DelApp", &DelApp::create);
    qmlRegisterSingletonType<DelTheme>(uri, 1, 0, "DelTheme", &DelTheme::create);
    qmlRegisterSingletonType<DelThemeFunctions>(uri, 1, 0, "DelThemeFunctions", &DelThemeFunctions::create);
}
