import consumer from './consumer'

$(document).on('turbolinks:load', function(){
    if (gon.question_id != null) {
        consumer.subscriptions.create({ channel: 'AnswersChannel', question_id: gon.question_id }, {
            received(data) {
                if (gon.user_id !== data.answer_author_id) {
                    $('.answers').append(`<div class="answer" data-answer-id="${data.answer_id}" ><p>${data.answer}</p></div>`)
                }
            }
        })
    }
})
