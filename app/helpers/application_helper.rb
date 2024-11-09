# frozen_string_literal: true

module ApplicationHelper
  def conditional_submit_button(form, text, action)
    if can?(action, form.object.class)
      form.submit text
    else
      form.submit text, onclick: 'showLoginAlert();'
    end
  end
end
