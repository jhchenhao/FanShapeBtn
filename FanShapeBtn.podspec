
Pod::Spec.new do |s|
  s.name         = "FanShapeBtn"
  s.version      = "0.0.1"
  s.summary      = "a btn"
  s.description  = <<-DESC
                   this is a btn like a fan
                   DESC
  s.homepage     = "https://github.com/GithubChinaCH/FanShapeBtn"
  s.license      = "MIT"
  s.author             = { "chenhao" => "xcodechenhao@163.com" }

  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source       = { :git => "https://github.com/GithubChinaCH/FanShapeBtn.git", :tag => "0.0.1" }

  s.source_files  = "Cls/class/*"


end

