#
#  Be sure to run `pod spec lint ScrollYearViewDemo.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "CustomScrollYearView"
  spec.version      = "1.1.1"
  spec.summary      = "自定义尺子的年度选择器"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  spec.description  = "自定义尺子的年度选择器"

  spec.homepage     = "http://EXAMPLE/ScrollYearViewDemo"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See https://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  spec.author             = { "Felix Yin" => "lafenglafenghaha@163.com" }
  # Or just: spec.author    = "Felix Yin"
  # spec.authors            = { "Felix Yin" => "lafenglafenghaha@163.com" }
  # spec.social_media_url   = "https://twitter.com/Felix Yin"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  #spec.platform     = :ios
  #支持iOS,版本最低9.0
  spec.platform     = :ios, "9.0"

  #  When using multiple platforms
  spec.ios.deployment_target = "9.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  #资源文件所在远程地址
  spec.source       = { :git => "https://github.com/FelixYin66/ScrollYearView.git", :tag => spec.version }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  #.h,.m文件相对文件地址
  spec.source_files  = "ScrollYearViewDemo/ScrollYearViewDemo/CustomScrollYearView/*.{h,m}"
  #自动生成子文件夹Layout，并按照source_files指定地址将文件放在Layout文件夹中
  spec.subspec 'Layout' do |la|
    la.source_files = "ScrollYearViewDemo/ScrollYearViewDemo/CustomScrollYearView/Layout/*.{h,m}"
  end

  spec.subspec 'Subviews' do |su|
    su.source_files = "ScrollYearViewDemo/ScrollYearViewDemo/CustomScrollYearView/Subviews/*.{h,m}"
  end

  spec.subspec 'Category' do |ct|
    ct.source_files = "ScrollYearViewDemo/ScrollYearViewDemo/Category/*.{h,m}"
  end
  #spec.exclude_files = "Classes/Exclude"

  # spec.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  #图片等其他一些资源文件  将指定文件夹下的CustomScrollYearView.bundle作为资源文件
  spec.resource  = "ScrollYearViewDemo/ScrollYearViewDemo/CustomScrollYearView.bundle"

  #这种方式添加资源文件 会自动创建ScrollYearViewDemo.bundle，此bundle中的资源文件都为Assets中的文件
  #spec.resource_bundles = {
   # 'ScrollYearViewDemo' => ['ScrollYearViewDemo/ScrollYearViewDemo/Assets/*']
  #}
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end
