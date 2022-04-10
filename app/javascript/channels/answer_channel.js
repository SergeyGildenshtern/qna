import consumer from './consumer'

$(document).on('turbolinks:load', function(){
    if (gon.question_id != null) {
        consumer.subscriptions.create({ channel: 'AnswersChannel', question_id: gon.question_id }, {
            received(data) {
                $('.answers').append(data.answer)

                if (gon.user_id) {
                    if (gon.user_id !== data.answer_author_id) {
                        RemoveAnswerAuthorElements()
                    }
                    if (gon.user_id !== data.question_author_id) {
                        RemoveQuestionAuthorElements()
                    }
                } else {
                    RemoveAnswerAuthorElements()
                    RemoveQuestionAuthorElements()
                }
            }
        })
    }
})

function RemoveQuestionAuthorElements() {
    $(`.answer[data-answer-id='${data.answer_id}'] .question-author-elements`).remove()
}

function RemoveAnswerAuthorElements() {
    $(`.answer[data-answer-id='${data.answer_id}'] .answer-author-elements`).remove()
}
