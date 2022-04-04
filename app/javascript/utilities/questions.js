$(document).on('turbolinks:load', function(){
    $('.edit-question-link').on('click', function(e) {
        e.preventDefault();
        $(this).hide();
        $('form#edit-question').removeClass('hidden');
    })

    $('form.new-answer').on('ajax:success', function(e) {
        let answer = e.detail[0];

        $('.answers').append('<div class="answer" data-answer-id="' + answer.id +'"><p>' + answer.body + '</p></div>');
    })
        .on('ajax:error', function (e) {
            let errors = e.detail[0];

            $('.answer-errors').html('<b>' + errors.length + ' error(s) detected:</b><ul></ul>');
            $.each(errors, function(index, value) {
                $('.answer-errors ul').append('<li>' + value + '</li>');
            })
        })
});
