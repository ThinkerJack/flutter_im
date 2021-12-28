import 'package:flutter/material.dart';

double getHeight(BuildContext context, List<String> list, String? title) {
  if (56.0 * (list.length) > MediaQuery.of(context).size.height * 0.8) {
    return MediaQuery.of(context).size.height * 0.8;
  }
  return 53.0 * (list.length) +
      (title != null ? 41 : 0) +
      72 +
      MediaQuery.of(context).padding.bottom;
}

class BottomActionSheet {
  static show(BuildContext context, List<String> data, Function(int) callBack,
      {String? title}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SafeArea(
            bottom: false,
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: getHeight(context, data, title)),
              child: Container(
                color: Color.fromRGBO(114, 114, 114, 1),
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    //为了防止控件溢出
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        decoration: new BoxDecoration(
                          color: Theme.of(context).buttonColor,
                          borderRadius:
                              new BorderRadius.all(Radius.circular(14)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            title != null
                                ? Container(
                                    height: 40,
                                    alignment: Alignment.center,
                                    child: new Text(
                                      title,
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : SizedBox(),
                            title != null
                                ? Divider(
                                    height: 1,
                                    color: Theme.of(context).dividerColor,
                                  )
                                : SizedBox(),
                            Flexible(
                              child: ListView.builder(
                                /**
                                        If you do not set the shrinkWrap property, your ListView will be as big as its parent.
                                        If you set it to true, the list will wrap its content and be as big as it children allows it to be. */
                                // shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      callBack(index);
                                    },
                                    child: Container(
                                      height: 53,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: index == data.length - 1
                                              ? BorderSide.none
                                              : BorderSide(
                                                  color: Color(0xFFF5F5F5),
                                                  width: 0.5,
                                                ),
                                        ),
                                      ),
                                      child: Text(
                                        data[index],
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 9,
                    ),
                    Container(
                      height: 53,
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                        color: Theme.of(context).buttonColor,
                        borderRadius: new BorderRadius.all(Radius.circular(14)),
                      ),
                      child: InkWell(
                        onTap: () {
                          //点击取消 弹层消失
                          Navigator.pop(context);
                        },
                        child: Text('取消',
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              color: Color(0xFF007AFF),
                              fontSize: 17.0,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
