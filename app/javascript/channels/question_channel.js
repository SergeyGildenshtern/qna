import consumer from './consumer'

$(document).on('turbolinks:load', function(){
    consumer.subscriptions.create('QuestionsChannel', {
        received(data) {
            $('.questions').append(data)
        }
    })
})
