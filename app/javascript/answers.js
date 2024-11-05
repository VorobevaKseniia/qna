$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e){
    e.preventDefault();
    $(this).hide();
    let answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  });

  $('form.new-answer').on('ajax:error', function(e) {
    let errors = e.detail[0];

    $('.answer-errors').empty();

    $.each(errors, function(index, value){
      $('.answer-errors').append('<p>' + value + '</p>')
    })
  })
});