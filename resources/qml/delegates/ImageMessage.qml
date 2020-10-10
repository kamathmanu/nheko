import QtQuick 2.6

import im.nheko 1.0

Item {
	property double tempWidth: Math.min(parent ? parent.width : undefined, model.data.width < 1 ? parent.width : model.data.width)
	property double tempHeight: tempWidth * model.data.proportionalHeight

	property double divisor: model.isReply ? 4 : 2
	property bool tooHigh: tempHeight > timelineRoot.height / divisor

	height: Math.round(tooHigh ? timelineRoot.height / divisor : tempHeight)
	width: Math.round(tooHigh ? (timelineRoot.height / divisor) / model.data.proportionalHeight : tempWidth)

	Image {
		id: blurhash
		anchors.fill: parent
		visible: img.status != Image.Ready

		source: model.data.blurhash ? ("image://blurhash/" + model.data.blurhash) : ("image://colorimage/:/icons/icons/ui/do-not-disturb-rounded-sign@2x.png?"+colors.buttonText)
		asynchronous: true
		fillMode: Image.PreserveAspectFit

		sourceSize.width: parent.width
		sourceSize.height: parent.height
	}

	Image {
		id: img
		anchors.fill: parent

		source: model.data.url.replace("mxc://", "image://MxcImage/")
		asynchronous: true
		fillMode: Image.PreserveAspectFit

		MouseArea {

			id: mouseArea
			enabled: model.data.type == MtxEvent.ImageMessage && img.status == Image.Ready
			anchors.fill: parent
			hoverEnabled: true

			onClicked: timelineManager.openImageOverlay(model.data.url, model.data.id)
		}

		Item {
			id: overlay
			anchors.fill: parent
			visible: mouseArea.containsMouse

			Rectangle {
				id: container
				
				width: parent.width			
				implicitHeight: imgcaption.implicitHeight
				anchors.bottom: overlay.bottom; anchors.right: overlay.right;
				color: "dimgray" 

				Text {
					id: imgcaption
					
					anchors.fill: parent
					
					elide: Text.ElideMiddle
					horizontalAlignment: Text.AlignHCenter
					verticalAlignment: Text.AlignVCenter
					
					// See this MSC: https://github.com/matrix-org/matrix-doc/pull/2530
					text: model.data.filename ? model.data.filename : model.data.body
					
					font.pointSize: 11
					color: "white"
				}
			}
		}
	}
}
