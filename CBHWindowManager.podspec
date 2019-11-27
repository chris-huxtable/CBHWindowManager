Pod::Spec.new do |spec|

  spec.name                   = 'CBHWindowManager'
  spec.version                = '1.0.2'
  spec.module_name            = 'CBHWindowManager'

  spec.summary                = 'An easy-to-use singleton which manages `NSWindow` and `NSWindowController` objects'
  spec.homepage               = 'https://github.com/chris-huxtable/CBHWindowManager'

  spec.license                = { :type => 'ISC', :file => 'LICENSE' }

  spec.author                 = { 'Chris Huxtable' => 'chris@huxtable.ca' }
  spec.social_media_url       = 'https://twitter.com/@Chris_Huxtable'

  spec.osx.deployment_target  = '10.10'

  spec.source                 = { :git => 'https://github.com/chris-huxtable/CBHWindowManager.git', :tag => "v#{spec.version}" }

  spec.requires_arc           = true

  spec.public_header_files    = 'CBHWindowManager/*.h'
  spec.private_header_files   = 'CBHWindowManager/_*.h'
  spec.source_files           = 'CBHWindowManager/*.{h,m}'

end
