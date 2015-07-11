jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  listing.setupForm()

listing =
  setupForm: ->
    $('#new_tutor_profile').submit ->
      $('input[type=submit]').attr('disabled', true)
      Stripe.bankAccount.createToken($('#new_tutor_profile'), listing.handleStripeResponse)
      false

  handleStripeResponse: (status, response) ->
    if status == 200
      $('#new_tutor_profile').append($('<input type="hidden" name="stripeToken" />').val(response.id))
      $('#new_tutor_profile')[0].submit()
    else
      $('#stripe_error').text(response.error.message).show()
      $('input[type=submit]').attr('disabled', false)