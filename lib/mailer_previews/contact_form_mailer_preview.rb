# frozen_string_literal: true

#
# ContactForm Mailer preview
# http://localhost:3000/rails/mailers/contact_form_mailer
# =============================
class ContactFormMailerPreview < ActionMailer::Preview
  def to_admin_preview
    @message = ContactForm.new default_attrs('cristiano', 'cristiano@ronaldo.pt')
    ContactFormMailer.to_admin(@message, :fr)
  end

  def copy_preview
    @message = ContactForm.new default_attrs('Karim', 'karim@benzema.fr')
    ContactFormMailer.copy(@message, :fr)
  end

  def answering_machine_preview
    ContactFormMailer.answering_machine('karim@benzema.fr', :en)
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
