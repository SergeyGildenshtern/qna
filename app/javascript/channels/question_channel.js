import consumer from './consumer'

$(document).on('turbolinks:load', function(){
    consumer.subscriptions.create('QuestionsChannel', {
        received(data) {
            $('.questions').append(`<li><a href="/questions/${data.question_id}/">${data.question}</a></li>`)
        }
    })
})
