
platform :ios, '10.0'
install! 'cocoapods', :deterministic_uuids => false, :warn_for_multiple_pod_sources => false

$BDMVersion = '~> 1.7.1.0'
$AppNexusVersion = '7.11'

def bidmachine
  pod "BDMIABAdapter", $BDMVersion
end

def appnexus 
  pod 'AppNexusSDK', $AppNexusVersion
end

target 'BidMachineSample' do
  appnexus
  bidmachine

end
