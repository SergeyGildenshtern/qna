$(document).on('turbolinks:load', function(){
    $('.edit-question-link').on('click', function(e) {
        e.preventDefault();
        $(this).hide();
        $('form#edit-question').removeClass('hidden');
    })

    $('form.new-answer').on('ajax:error', function (e) {
        let errors = e.detail[0];

        $('.answer-errors').html('<b>' + errors.length + ' error(s) detected:</b><ul></ul>');
        $.each(errors, function(index, value) {
            $('.answer-errors ul').append('<li>' + value + '</li>');
        })
    })
});
