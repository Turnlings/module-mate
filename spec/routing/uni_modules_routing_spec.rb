require "rails_helper"

RSpec.describe UniModulesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/uni_modules").to route_to("uni_modules#index")
    end

    it "routes to #new" do
      expect(get: "/uni_modules/new").to route_to("uni_modules#new")
    end

    it "routes to #show" do
      expect(get: "/uni_modules/1").to route_to("uni_modules#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/uni_modules/1/edit").to route_to("uni_modules#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/uni_modules").to route_to("uni_modules#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/uni_modules/1").to route_to("uni_modules#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/uni_modules/1").to route_to("uni_modules#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/uni_modules/1").to route_to("uni_modules#destroy", id: "1")
    end
  end
end
