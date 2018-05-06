import QtQuick 1.1

MouseArea{

    id: mainMouseArea

    property bool enabled: true
    property string flickDirection
    property int    oldMouseX : 0

    anchors.fill: parent

    drag.target:  {
        if( mainWnd.state == "control" ){
            return setupWnd;
        }
        else{
            return controlWnd;
       }
    }

    drag.axis: {
        if( mainMouseArea.enabled == false ){
            return 0;
        }else{
            return Drag.XAxis;
        }
    }

    drag.minimumX: -mainWnd.width
    drag.maximumX: mainWnd.width;


    onPressed:{
         var item =  mainWnd.mapFromItem(mainMouseArea, mouse.x, mouse.y) ;
        oldMouseX = item.x
        if( mainWnd.state == "control" ){
            setupWnd.x  = - ( setupWnd.width /2 );
        }
        else{
            controlWnd.x = -( controlWnd.width /2 );
        }
    }

    onPositionChanged: {
        var item =  mainWnd.mapFromItem(mainMouseArea, mouse.x, mouse.y) ;

        if ( drag.active == true ){
            if( oldMouseX > item.x){
                flickDirection = "left";
                // 드레그가 먹히므로 제자리로 view 값 돌림
                return;
            }
            else {
                flickDirection = "right";
            }

            setup.opacity = 1;
            control.opacity = 1;
            if( mainWnd.state == "control"){
                setup.z = controlWnd.z + 1;
            }
            else {
                control.z = setupWnd.z + 1;
            }
        }

    }

    onReleased:{
        if( drag.active == true ){
            if ( flickDirection == "right" )
            {
                if( mainWnd.state == "control" ){
                    mainWnd.state = "setup";
                    setupWnd.x = 0;
                    controlWnd.x = 0;

                }
                else{

                    mainWnd.state = "control"
                    controlWnd.x = 0;
                    setupWnd.x  = 0;

                }

            }
        }
    }

}
