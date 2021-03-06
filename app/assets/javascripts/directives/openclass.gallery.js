angular.module('openClass.directives')
.directive('gallery', function factory(fancybox) {
  var directive = {
    restrict: 'C',
    link: function (scope, element, attrs) {
      scope.$watch('attachments', function (attachments) {
        if (attachments) {
          fancybox(element.find('a'), {
            afterShow: function() {
              var fileType = this.element.parents('ul').data('file-type');
              _gaq.push(['_trackEvent', 'Attachment', 'View', fileType]);

              $('#fancybox-thumbs').remove();
              var url = "attachments/" + this.element.attr('attachment_id') + "/comments";
              $.ajax(url, {
                type: 'get',
                dataType: 'html',
                success: function(partial) {
                  $('.fancybox-title').after($("<div>" + partial + "</div>"));
                  $('#comments_form').submit(function() {
                    $.ajax($(this).attr('action'), {
                      type: 'POST',
                      dataType: 'html',
                      data: { 'comment[content]' : $('#comment_content').val(), authenticity_token: $('meta[name="csrf-token"]').attr('content') },
                      success: function(partial) {
                        $('#comments_list').prepend(partial);
                        $('#comment_content').val('');
                      }
                    });
                    return false
                  })
                }
              })
            },
            helpers:{
              title:{
                type:'inside'
              },
              thumbs:{
                width:50,
                height:50
              }
            }
          });
        }
      });
    }
  };

  return directive;
});
