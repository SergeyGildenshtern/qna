$(document).on('turbolinks:load', function(){
    $('.voting form.new-vote').on('ajax:success', function(e) {
        let result = e.detail[0];
        $(`[data-votable-id='${result.votable.id}'] .result`).html(`Rating: ${result.rating}`);

        if ($(this).hasClass('vote-up')) {
            $('.voting form.vote-down input[type="submit"]').attr("disabled", result.new_vote);
        } else {
            $('.voting form.vote-up input[type="submit"]').attr("disabled", result.new_vote);
        }
    });
});
