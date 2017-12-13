## A non-trivial e-commerce application, a clone of NetFlix

# Technology used to build MyFlix
- TDD with RSpec, Capybara, VCR and Selenium
- Test doubles and method stubs
- Advanced search on Videos with ELasticsearch
- Subscription and full payment processing with Stripe
- File storage with Amazon S3

# Features
- User with full account management:
  * authentication with bcrypt
  * add/delete/reorder videos from their videos queue
  * reset password by sending an email with a link
  * invite friends to join(with invitation token)
  * follow and unfollow users 
- Admin capabilities: add videos, video images and view payments 