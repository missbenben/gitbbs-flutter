import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:gitbbs/model/cachemanager/edit_text_cache_manager.dart';
import 'package:gitbbs/network/image_helper.dart';
import 'package:gitbbs/ui/editcomment/action.dart';
import 'package:gitbbs/ui/editcomment/state.dart';
import 'package:gitbbs/model/entry/comment_edit_data.dart';
import 'package:gitbbs/ui/markdownhelp/markdown_help_page.dart';
import 'package:markdown_editor/markdown_editor.dart';

Widget buildView(
    EditCommentState state, Dispatch dispatch, ViewService viewService) {
  String title = '添加评论';
  if (state.type == Type.modify) {
    title = '修改评论';
  } else if (state.type == Type.reply) {
    title = '回复评论';
  }
  return Scaffold(
    key: state.scaffoldKey,
    appBar: AppBar(
      title: Text(title),
      actions: <Widget>[
        Center(
          child: InkWell(
            child: Padding(
              padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
              child: Text(
                  state.getCurrentPage() == PageType.editor ? '预览' : '编辑',
                  style: TextStyle(fontSize: 16)),
            ),
            onTap: () {
              dispatch(EditCommentActionCreator.togglePageTypeAction());
            },
          ),
        ),
        Center(
          child: InkWell(
            child: Padding(
              padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
              child: Text(
                '提交',
                style: TextStyle(fontSize: 16),
              ),
            ),
            onTap: () {
              dispatch(EditCommentActionCreator.checkSubmitCommentAction());
            },
          ),
        ),
        Center(
          child: InkWell(
            child: Padding(
              padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
              child: Text('帮助', style: TextStyle(fontSize: 16)),
            ),
            onTap: () {
              Navigator.of(viewService.context).push(
                  MaterialPageRoute(builder: (context) => MarkdownHelpPage()));
            },
          ),
        ),
      ],
    ),
    body: Center(
      child: MarkdownEditor(
        key: state.mdKey,
        tabChange: (type) {
          dispatch(EditCommentActionCreator.pageTypeChangedAction());
        },
        imageSelect: () async {
          var url = await ImageHelper.pickAndUpload(viewService.context);
          return url;
        },
        textChange: () {
          EditTextCacheManager.save(state.getCacheKey(),
              state.mdKey.currentState.getMarkDownText().text);
        },
        initText: state?.initText?.isNotEmpty == true
            ? state.initText
            : state.type == Type.modify ? state.comment.getBody() ?? "" : "",
        padding: const EdgeInsets.all(10),
      ),
    ),
  );
}
