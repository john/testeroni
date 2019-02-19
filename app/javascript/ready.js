window.Testeroni = {};

$(document).on('turbolinks:load', function() {

  $('[data-role=sortable_items]').each(function() {
    new Testeroni.SortableItems($(this));
  });

  // horrible documentation, the table hides the fact that the values are hidden in a single 'event' param
  $('#answer-form').on('ajax:success', function(event) {
    console.log( event.detail );
    $('.replace-me').html(event.detail[0])
  });

  // When processing a request failed on the server, it might return the error message as HTML:
  //
  // $('#account_settings').on('ajax:error', function(event, xhr, status, error) {
  //   // insert the failure message inside the "#account_settings" element
  //   $(this).append(xhr.responseText)
  // });

});

