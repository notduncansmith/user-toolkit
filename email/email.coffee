module.exports = (mailer, mailConfig, mustache, Promise, templates) ->
  class Email
    templates: templates

    sendWithTemplate: (user, templateName, data, tag) ->
      t = @templates[templateName]
      tag ?= 'misc'
      data.user = user
      @renderTemplate t.template, data
      .then (contents) =>
        @send user, t.subject, contents, tag

    send: (user, subject, contents, tag) ->
      recipient = 
        email: user.email
        name: user.fullName()
        type: 'to'

      message =
        text: contents,
        subject: subject
        from_email: mailConfig.fromEmail
        from_name: mailConfig.fromName
        to: [recipient]
        important: true
        tags: [tag]

      new Promise (resolve, reject) ->
        mailer.messages.send {message:message}, (response) ->
          resolve response

    renderTemplate: (template, data) ->
      new Promise (resolve, reject) ->
        contents = mustache.render template, data
        resolve contents

