require "rails_helper"

describe Api::V1::RegionsController, type: :controller do
  describe "accepting requests" do
    context "with incorrect token" do
      before do
        request.env["HTTP_AUTHORIZATION"] = ActionController::HttpAuthentication::Token.encode_credentials("1234")
      end

      it "returns an forbidden status code" do
        get :show, id: 1
        expect_status :forbidden
      end
    end

    context "with correct token" do
      before do
        @region = FactoryGirl.create :region, name: "Test1"
        location = FactoryGirl.create :location, region: @region
        @user = FactoryGirl.create :user, location: location
        authenticate_for_specs(@user)
      end

      describe "#create" do
        it "creates and returns a region instance" do
          post :create, name: @region.name,
            abbreviation: @region.abbreviation, time_zone: @region.time_zone,
            admin_notes: @region.admin_notes
          expect_json("data", attributes: { name: @region.name, abbreviation: @region.abbreviation })
        end

        it "validates json attribute types" do
          post :create, name: @region.name,
            abbreviation: @region.abbreviation, time_zone: @region.time_zone,
            admin_notes: @region.admin_notes
          expect_json_types("data", id: :string)
          expect_json_types("data", attributes: { name: :string })
          expect_json_types("data", attributes: { abbreviation: :string })
          expect_json_types("data", attributes: { time_zone: :string })
          expect_json_types("data", attributes: { archived: :boolean })
          expect_json_types("data", attributes: { test: :boolean })
        end

        it "returns a status of 201" do
          post :create, name: @region.name,
            abbreviation: @region.abbreviation, time_zone: @region.time_zone,
            admin_notes: @region.admin_notes
          expect_status :created
        end

        it "creates a new instance" do
          expect { post :create, name: @region.name,
            abbreviation: @region.abbreviation, time_zone: @region.time_zone,
            admin_notes: @region.admin_notes
          }.to change(Region, :count).by(1)
        end
      end

      describe "#show" do
        it "returns a region instance" do
          get :show, id: @region.id
          expect_json("data", attributes: { name: @region.name, abbreviation: @region.abbreviation })
        end

        it "validates json attribute types" do
          get :show, id: @region.id
          expect_json_types("data", id: :string)
          expect_json_types("data", attributes: { name: :string })
          expect_json_types("data", attributes: { abbreviation: :string })
          expect_json_types("data", attributes: { time_zone: :string })
          expect_json_types("data", attributes: { archived: :boolean })
          expect_json_types("data", attributes: { test: :boolean })
        end

        it "returns a status of 200" do
          get :show, id: @region.id
          expect_status :ok
        end
      end

      describe "#index" do
        it "returns a collection of regions" do
          @region_2 = FactoryGirl.create :region
          @region_3 = FactoryGirl.create :region
          get :index
          expect_json_sizes("data", 3)
        end

        it "includes at least one of the instances" do
          @region_2 = FactoryGirl.create :region
          @region_3 = FactoryGirl.create :region
          get :index
          expect_json("data.?", attributes: { name: @region_2.name, abbreviation: @region_2.abbreviation })
        end

        it "returns a status of 200" do
          @region_2 = FactoryGirl.create :region
          @region_3 = FactoryGirl.create :region
          get :index
          expect_status :ok
        end
      end

      describe "#update" do
        it "updates the region" do
          put :update, id: @region.id, name: "New name"
          expect_json("data", attributes: { name: "New name", abbreviation: @region.abbreviation })
        end

        it "validates the json attribute types" do
          put :update, id: @region.id, name: "New name"
          expect_json_types("data", id: :string)
          expect_json_types("data", attributes: { name: :string })
          expect_json_types("data", attributes: { abbreviation: :string })
          expect_json_types("data", attributes: { time_zone: :string })
          expect_json_types("data", attributes: { archived: :boolean })
          expect_json_types("data", attributes: { test: :boolean })
        end

        it "returns a status of accepted (202)" do
          put :update, id: @region.id, name: "New name"
          expect_status :accepted
        end
      end

      describe "#delete" do
        it "returns empty json" do
          delete :destroy, id: @region.id
          expect_json_sizes 0
        end

        it "returns a status of accepted (202)" do
          delete :destroy, id: @region.id
          expect_status :accepted
        end

        it "deletes the specified instance" do
          expect { delete :destroy, id: @region.id }.to change(Region, :count).by(-1)
        end
      end
    end
  end
end
