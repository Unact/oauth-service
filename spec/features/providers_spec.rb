require 'helpers/spec_helper'

RSpec.feature OauthService::Providers do
  context "has correct" do
    before :each do
      @providers = OauthService::Providers.list
    end

    it "list" do
      @providers.each do |provider|
        expect(OauthService.available_providers).to include(provider.class)
        expect(provider.is_a? OauthService::Provider).to eq(true)
      end
    end

    it "by_name" do
      @providers.each do |provider|
        expect(OauthService::Providers.by_name(provider.name)).to eq(provider)
      end

      expect(OauthService::Providers.by_name('wrong_name')).to eq(nil)
    end
  end
end
