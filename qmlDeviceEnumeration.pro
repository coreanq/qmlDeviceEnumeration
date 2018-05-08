QT += quick
CONFIG += c++11 
#CONFIG += v-play

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

Debug {
    #DEPLOYMENTFOLDERS 해당 리소스를 showdow 빌드 디렉토리로 qrc 로 컴파일 하지 않고 복사함
    qmlFolder.source = qml
    DEPLOYMENTFOLDERS += qmlFolder

    assetsFolder.source = image
    DEPLOYMENTFOLDERS += assetsFolder
    RESOURCES += resource.qrc
}
Release{
    RESOURCES += resource.qrc
}

SOURCES += \
        main.cpp \
    qmlstandarditemmodel.cpp \
    qmlsortfilterproxymodel.cpp \
    qmlinterface.cpp

RESOURCES += \
    resource.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    qml/functions.js \
    qml/ActualValueSlider.qml \
    qml/Button.qml \
    qml/ControlWnd.qml \
    qml/Group.qml \
    qml/GroupBox.qml \
    qml/GroupSettingPage.qml \
    qml/Logo.qml \
    qml/LogWnd.qml \
    qml/MainMouseArea.qml \
    qml/NavigationWnd.qml \
    qml/NetworkInterface.qml \
    qml/Picker.qml \
    qml/ProgressBar.qml \
    qml/RegisteredTxZones.qml \
    qml/ScrollBar.qml \
    qml/SettingPage.qml \
    qml/SetupWnd.qml \
    qml/Shine.qml \
    qml/SlideSwitch.qml \
    qml/Zone.qml \
    qml/ZoneSettingPage.qml \
    qml/Main.qml \
    qml/setupcomponent/SourceWnd.qmlc \
    qml/setupcomponent/ZoneWnd.qmlc \
    qml/setupcomponent/DbWnd.qml \
    qml/setupcomponent/SourceWnd.qml \
    qml/setupcomponent/ZoneWnd.qml \
    image/*.png

HEADERS += \
    qmlstandarditemmodel.h \
    qmlsortfilterproxymodel.h \
    qmlinterface.h
