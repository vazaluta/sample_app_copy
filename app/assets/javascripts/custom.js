// // textarea の高さ自動調整

// $(function() {
//   var $textarea = $('#micropost_content');
//   var lineHeight = parseInt($textarea.css('lineHeight'));
//   $textarea.on('input', function(e) {
//     var lines = ($(this).val() + '\n').match(/\n/g).length;
//     $(this).height(lineHeight * lines);
//   });
//   console.log($textarea)
// });

// //textareaの要素を取得
// let textarea = document.getElementById('textarea');
// //textareaのデフォルトの要素の高さを取得
// let clientHeight = textarea.clientHeight;

// //textareaのinputイベント
// textarea.addEventListener('input', ()=>{
//     //textareaの要素の高さを設定（rows属性で行を指定するなら「px」ではなく「auto」で良いかも！）
//     textarea.style.height = clientHeight + 'px';
//     //textareaの入力内容の高さを取得
//     let scrollHeight = textarea.scrollHeight;
//     //textareaの高さに入力内容の高さを設定
//     textarea.style.height = scrollHeight + 'px';
// });