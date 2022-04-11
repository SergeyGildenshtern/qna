import consumer from './consumer'

$(document).on('turbolinks:load', function(){
    consumer.subscriptions.create('CommentsChannel', {
        received(data) {
            let comment = document.createElement("li")
            let author = document.createElement("p")
            let text = document.createElement("p")

            author.textContent = data.author_email
            text.textContent = data.comment

            comment.appendChild(author)
            comment.appendChild(text)

            $(`.${data.commentable_type}-${data.commentable_id}-comments .comments`).append(comment);
        }
    })
})
