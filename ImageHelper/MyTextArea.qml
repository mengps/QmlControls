import QtQuick 2.15
import QtQuick.Controls 2.15
import an.controls 1.0

TextArea {
    id: editor
    smooth: true
    textFormat: Text.RichText
    selectionColor: "#3399FF"
    selectByMouse: true
    selectByKeyboard: true
    wrapMode: TextEdit.Wrap

    function insertImage(src) {
        imageHelper.insertImage(src);
    }

    function cleanup() {
        editor.remove(0, length)
        imageHelper.cleanup();
    }

    ImageHelper {
        id: imageHelper
        document: editor.textDocument
        cursorPosition: editor.cursorPosition
        selectionStart: editor.selectionStart
        selectionEnd: editor.selectionEnd
        onNeedUpdate: {
            //editor.update() 这句不起作用，编辑器未改变，就不会更新，用下面的方法
            let alpha = editor.color.a;
            editor.color.a = alpha - 0.01;
            editor.color.a = alpha;
        }
    }
}
