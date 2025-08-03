class Page < ApplicationRecord
  validates :slug, presence: true, uniqueness: true
  validates :title, presence: true
  validates :content, presence: true

  # Find page by slug
  def self.find_by_slug(slug)
    find_by(slug: slug)
  end

  # Create default pages if they don't exist
  def self.ensure_default_pages_exist
    create_default_page('about', 'About Us', default_about_content) unless find_by_slug('about')
    create_default_page('contact', 'Contact Us', default_contact_content) unless find_by_slug('contact')
  end

  private

  def self.create_default_page(slug, title, content)
    create!(slug: slug, title: title, content: content)
  end

  def self.default_about_content
    <<~CONTENT
      <h3>Our Story</h3>
      <p>Swimi is your premier destination for high-quality swimwear for the entire family. Founded with a passion for aquatic lifestyle, we've been providing swimmers, beach-goers, and water sports enthusiasts with the best swimwear since our inception.</p>
      
      <p>Whether you're looking for competitive swimwear, casual beachwear, or fun kids' designs, our curated collection ensures that everyone can find their perfect fit and style.</p>

      <h3>Our Mission</h3>
      <p>To provide high-quality, comfortable, and stylish swimwear that enhances your aquatic experience while promoting an active and healthy lifestyle.</p>

      <h3>Why Choose Swimi?</h3>
      <ul>
        <li>Premium quality materials</li>
        <li>Wide range of sizes and styles</li>
        <li>Competitive prices</li>
        <li>Excellent customer service</li>
        <li>Fast and reliable shipping</li>
      </ul>
    CONTENT
  end

  def self.default_contact_content
    <<~CONTENT
      <h3>Get in Touch</h3>
      <p>We'd love to hear from you! Whether you have questions about our products, need sizing advice, or want to share feedback, our team is here to help.</p>

      <h3>Contact Information</h3>
      <div class="row">
        <div class="col-md-6">
          <h4>Customer Service</h4>
          <p><strong>Email:</strong> support@swimi.com</p>
          <p><strong>Phone:</strong> 1-800-SWIMI-US</p>
          <p><strong>Hours:</strong> Monday - Friday, 9 AM - 6 PM EST</p>
        </div>
        <div class="col-md-6">
          <h4>Store Location</h4>
          <p>123 Beach Avenue<br>
          Seaside City, SC 12345<br>
          United States</p>
        </div>
      </div>

      <h3>Online Support</h3>
      <p>For immediate assistance, you can also reach us through our live chat feature or by filling out our contact form below.</p>
    CONTENT
  end
end
