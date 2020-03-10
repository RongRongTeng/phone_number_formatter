# Phone Number Formatter

A feature for UK mobile phone number parsing and formatting.


## Prerequisites

- [Ruby](https://www.ruby-lang.org/en/documentation/installation/) - this project is developed with ruby 2.6.3
- [Bundler](https://bundler.io/)
```
 gem install bundler
```

## Getting Started

### Purpose

We collect customer's UK phone number on checkout, so we can send reminders and useful information about their delivery with SMS to our customers by using [Twilio](https://www.twilio.com/docs/sms/quickstart/ruby).

Twilio requires the phone number to be formatted correctly before being sent to Twilio - for UK mobile phone numbers, it should include the +44 prefix.

This feature is implemented on the purpose of **parsing and getting the formatted phone number**.

Some rules to be noticed:

1. UK phone number only
2. Phone number starts from the following format and 7 always after it
- +447...
- 447...
- 07...
3. 11 digits long when in the 07... format. So, it means after the prefix, it always has 9 digits
4. Without any space


### Installation

After cloning the repository ...
```
bundle install
```

### Basic Usage

You can include/extend this module on your classes using it to attach specific behavior OR use [IRB](https://www.ruby-lang.org/en/documentation/quickstart/) for a try first!

#### For IRB:

Require the file
```ruby
require '[YourPathOfTheDirectory]/phone_number_formatter/formatter/phone_number/uk'
# => true
```

Get formatted phone number

```ruby
Formatter::PhoneNumber::UK.format('4471234 56789')
# => '+447123456789'

Formatter::PhoneNumber::UK.format('+4471234 56789')
# => '+447123456789'

Formatter::PhoneNumber::UK.format('071234 56789')
# => '+447123456789'
```

If the phone number format is invalid, it will raise an error
```ruby
# not starts from +447, 447, or 07
Formatter::PhoneNumber::UK.format('0634343')
# => Formatter::PhoneNumber::UK::InvalidPrefix (Formatter::PhoneNumber::UK::InvalidPrefix)

# 8 digits length after prefix
Formatter::PhoneNumber::UK.format('+447 12345678')
# => Formatter::PhoneNumber::UK::InvalidDigitLength (Formatter::PhoneNumber::UK::InvalidDigitLength)

# contains invalid character
Formatter::PhoneNumber::UK.format('+4471234 5678s')
# => Formatter::PhoneNumber::UK::InvalidPhoneNumber (Formatter::PhoneNumber::UK::InvalidPhoneNumber)
```

### Guide to Implementation

Using TDD(Test Driven Development). So... start out with reading spec helps you get into the code!

This formatter use the **regular expression** to parse and validate the phone number. If the input phone number matches the pattern of the defined format, it will return the formatted one. If not, it will raise an error.

Here go through a little more about ...

**Working with named captures**

Tag the capture group with names can help with getting data out of the match object, for example, group #1 is named *prefix*.

```ruby
Formatter::PhoneNumber::UK::FORMAT_REGEXP = /^(?<prefix>\+44|44|0)(?<fixed_digit>7)(?<digits>\d{9})$/ 
```
In the [code](https://github.com/RongRongTeng/phone_number_formatter/blob/master/formatter/phone_number/uk.rb#L22), group *digits* is the only one been used, but making clear definition of capture group will help for the future further development and readability.

More information please read [here](https://ruby-doc.org/core-2.6.3/MatchData.html) of Ruby MatchData

**Error Types**

There are three types of errors defined in this feature.

```ruby
Formatter::PhoneNumber::UK::InvalidPrefix
Formatter::PhoneNumber::UK::InvalidDigitLength
Formatter::PhoneNumber::UK::InvalidPhoneNumber
```

First, check whether the prefix is valid. If it's not, raise specific **InvalidPrefix** error. Then, validate the length of the digits. If it’s not 9 digits after the prefix, raise specific **DigitLength** error. All other uncertain errors will raise **InvalidPhoneNumber** error.


## Testing

Unit Test with [RSpec](https://github.com/rspec/rspec)

```
bundle exec rspec
```

## Better in the future

- There are some limitations to errors. The input phone number might have multiple errors, like '+123uk' with invalid prefix, digits length, and characters. Now can only validate step by step, it should be able to validate all at one time or under some conditions, as well as do error handling. To Make sure that this feature lists all the possible errors of the input to the user.

- Extract the rule of phone number out to a configuration file let phone number formatter become more general. Not only for UK phone number, but also other countries' phone number pattern can use this configuration file to define. Then, it should be able to parse and return the formatted phone number determined by the country.


## Author

- **Ya-Rong, Teng** - [RongRongTeng](https://github.com/RongRongTeng)

## License
[MIT](https://github.com/RongRongTeng/phone_number_formatter/blob/master/LICENSE) - Copyright (c) 2020 Ya-Rong, Teng
