
function isPtInGroups(parent, mouseX, mouseY){

    var srcObj = parent.mapToItem(mainWnd, mouseX, mouseY);
    var dstObj = viewGroups.mapToItem(mainWnd, viewGroups.x, viewGroups.y);

    console.debug("src x " + srcObj.x + " src y " + srcObj.y + " dst x " + dstObj.x + " dst y " + dstObj.y);
    if(  srcObj.x >= dstObj.x && srcObj.x <= (dstObj.x + viewGroups.width) &&
            srcObj.y >= dstObj.y && srcObj.y <= (dstObj.y + viewGroups.height )){
        return true;
    }
    else
        return false;
}



function indexInRegisteredTxZones(parent, mouseX, mouseY){
    var srcObj = parent.mapToItem(mainWnd, mouseX, mouseY);
    var registeredTxZonesObj= parent.mapToItem(viewRegisteredTxZones, mouseX, mouseY);
    return viewRegisteredTxZones.indexAt(registeredTxZonesObj.x, registeredTxZonesObj.y);
}

function isPtInRegisteredTxZones(parent, mouseX, mouseY){

    var srcObj = parent.mapToItem(mainWnd, mouseX, mouseY);
    var dstObj = viewRegisteredTxZones.mapToItem(mainWnd, viewRegisteredTxZones.x, viewRegisteredTxZones.y);

//    console.debug("src x " + srcObj.x + " src y " + srcObj.y + " dst x " + dstObj.x + " dst y " + dstObj.y);

    if(  srcObj.x >= dstObj.x && srcObj.x <= (dstObj.x + viewRegisteredTxZones.width) &&
            srcObj.y >= dstObj.y && srcObj.y <= (dstObj.y + viewRegisteredTxZones.height )){
        return true;
    }
    else
        return false;
}

function isPtInTxZones(parent, mouseX, mouseY){

    var srcObj = parent.mapToItem(mainWnd, mouseX, mouseY);
    var dstObj = viewTxZones.mapToItem(mainWnd, viewTxZones.x, viewTxZones.y);

    if(  srcObj.x >= dstObj.x && srcObj.x <= (dstObj.x + viewTxZones.width) &&
            srcObj.y >= dstObj.y && srcObj.y <= (dstObj.y + viewTxZones.height )){
        return true;
    }
    else
        return false;
}

