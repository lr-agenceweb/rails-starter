#
# == ContactForm Mailer preview
# Preview all emails at http://localhost:3000/rails/mailers/contact_form_mailer
#
class ContactFormMailerPreview < ActionMailer::Preview
  def message_me_preview
    attrs = {
      name: 'cristiano',
      email: 'cristiano@ronaldo.pt',
      message: 'Hi, Lorem ipsum dolor sit amet, consectetur adipisicing elit. Dignissimos minus atque accusantium quos perspiciatis dolor itaque dicta nulla architecto ut quaerat sequi nostrum, earum magni doloribus maxime tempore quam sapiente.',
    }

    @message = ContactForm.new attrs

    I18n.with_locale(:fr) do
      ContactFormMailer.message_me(@message)
    end
  end
end
