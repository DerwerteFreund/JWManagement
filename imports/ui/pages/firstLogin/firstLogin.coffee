import './firstLogin.tpl.jade'

Template.firstLogin.helpers

	getErrorMessage: -> Session.get('errorMessage')

Template.firstLogin.events

	'submit form': (event) ->
		event.preventDefault()

		username = $('#username').val()
		password1 = $('#password1').val()
		password2 = $('#password2').val()
		agreeTerms = $('#agreeTerms').prop('checked')
		token = FlowRouter.getQueryParam('token')

		try
			if token
				if agreeTerms
					if username
						if Meteor.users.helpers.areValidPasswords password1, password2
							Meteor.users.methods.checks.usernameAvailable.call
								username: username
							, (err, res) ->
								if res
									Meteor.users.methods.init.call
										token: token
										username: username
										password: password1
									, (err, res) ->
										if typeof res == 'object' && res.done
											Meteor.loginWithPassword username, password1, -> FlowRouter.go 'home'
										else
											swal TAPi18n.__('firstLogin.tokenError', 'error')
								else
									swal TAPi18n.__('firstLogin.usernameExists', 'error')
					else
						throw new Meteor.Error 'firstLogin.usernameMissing', ''
				else
					throw new Meteor.Error 'firstLogin.agreeTermsMissing', ''
			else
				throw new Meteor.Error 'firstLogin.tokenMissing', ''
		catch e
			swal TAPi18n.__(e.error, 'error')