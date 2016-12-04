# frozen_string_literal: true

#
# == ContactForm Mailer preview
# Preview all emails at http://localhost:3000/rails/mailers/contact_form_mailer
#
class ContactFormMailerPreview < ActionMailer::Preview
  def message_me_preview
    @message = ContactForm.new default_attrs('cristiano', 'cristiano@ronaldo.pt')

    I18n.with_locale(:fr) do
      ContactFormMailer.message_me(@message)
    end
  end

  def send_copy_preview
    @message = ContactForm.new default_attrs('Karim', 'karim@benzema.fr')

    I18n.with_locale(:fr) do
      ContactFormMailer.send_copy(@message)
    end
  end

  def answering_machine_preview
    ContactFormMailer.answering_machine('karim@benzema.fr', :fr)
  end

  private

  def default_attrs(name, email)
    {
      name: name,
      email: email,
      message: 'Hi, Lorem ipsum dolor sit amet, consectetur adipisicing elit. Dignissimos minus atque accusantium quos perspiciatis dolor itaque dicta nulla architecto ut quaerat sequi nostrum, earum magni doloribus maxime tempore quam sapiente.'
    }
  end
end
