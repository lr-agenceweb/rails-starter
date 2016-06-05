# frozen_string_literal: true

#
# == LegalNotice articles
#
puts 'Creating LegalNotice article'
legal_notice_title_fr = [
  'Hébergement du site',
  'Nom de domaine'
]
legal_notice_title_en = [
  'Site hosting',
  'Domain name'
]
legal_notice_slug_fr = [
  'hebergement-du-site',
  'nom-de-domaine'
]
legal_notice_slug_en = [
  'site-hosting',
  'domain-name'
]
legal_notice_content_fr = [
  '<p><strong>Ce site est hébergé par</strong>: <br>  Hébergeur : ONLINE SAS<br>  Adresse web : <a href="https://www.online.net/fr">https://www.online.net</a><br>Téléphone : +33.(0)1.84.13.00.00<br>TVA : FR 35 433115904</p><p><strong>Adresse Postale</strong>: <br>  ONLINE SAS<br>  BP 438 75366<br>  PARIS CEDEX 08</p>',
  '<p><strong>Le nom de domaine provient de</strong> :<br>  Hébergeur : OVH SAS<br>  Adresse web : <a href="https://www.ovh.com">https://www.ovh.com</a><br>  Téléphone: 1007<br>  SAS au capital de 10 059 500 €<br>  RCS Lille Métropole 424 761 419 00045<br>  Code APE 6202A<br>  N° TVA : FR 22 424 761 419</p><p><strong>Siège social</strong> :<br>  2 rue Kellermann<br>  59100 Roubaix<br>  France</p>'
]
legal_notice_content_en = [
  '<p><strong>This website is hosted by</strong>: <br>  Host : ONLINE SAS<br> Website : <a href="https://www.online.net/fr">https://www.online.net</a><br>Phone : +33.(0)1.84.13.00.00<br>TVA : FR 35 433115904<br></p><p><strong>Postal address</strong>: <br>  ONLINE SAS<br>  BP 438 75366<br>  PARIS CEDEX 08</p>',
  '<p><strong>The domain name come from</strong> :<br>  Host : OVH SAS<br>Website : <a href="https://www.ovh.com">https://www.ovh.com</a><br>  Phone: 1007<br>  SAS au capital de 10 059 500 €<br>  RCS Lille Métropole 424 761 419 00045<br>  Code APE 6202A<br>  N° TVA : FR 22 424 761 419</p><p><strong>Head office</strong> :<br>  2 rue Kellermann<br>  59100 Roubaix<br>  France</p>'
]
legal_notice_user_id = [
  @super_administrator.id,
  @super_administrator.id
]

legal_notice_title_fr.each_with_index do |element, index|
  legal_notice = LegalNotice.new(
    title: legal_notice_title_fr[index],
    slug: legal_notice_slug_fr[index],
    content: legal_notice_content_fr[index],
    online: true,
    user_id: legal_notice_user_id[index]
  )
  legal_notice.save(validate: false)

  if @locales.include?(:en)
    lnt = LegalNotice::Translation.new(
      post_id: legal_notice.id,
      locale: 'en',
      title: legal_notice_title_en[index],
      slug: legal_notice_slug_en[index],
      content: legal_notice_content_en[index]
    )
    lnt.save(validate: false)
  end
end
