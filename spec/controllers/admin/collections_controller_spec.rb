require "rails_helper"

describe Admin::CollectionsController do
  let(:collection) { create(:collection) }
  let!(:collections) { [collection] }

  before do
    stub_auth
  end

  describe "POST #create" do
    before do
      post :create, collection: collection_attributes
    end

    context "with valid attributes" do
      let(:collection_attributes) { attributes_for(:collection) }

      it "assigns collection" do
        expect(controller.collection).to be_a(Collection)
        expect(controller.collection.new_record?).to be true
      end

      it "redirects to group edit page" do
        expect(controller).to redirect_to(edit_admin_group_path)
      end
    end

    context "with invalid attributes" do
      let(:collection_attributes) { attributes_for(:collection).slice!(:name) }

      it "redirects to group edit page" do
        expect(controller).to redirect_to(edit_admin_group_path)
      end
    end
  end

  describe "PUT #update" do
    let!(:collection) { create(:collection) }

    before do
      patch :update, id: collection.id, collection: collection_attributes
    end

    context "with valid attributes" do
      let(:collection_attributes) { attributes_for(:collection) }

      it "assigns collection" do
        expect(controller.collection).to eq(collection)
      end

      it "redirects to collection" do
        expect(controller).to redirect_to(edit_admin_group_path)
      end
    end

    context "with invalid attributes" do
      let(:collection_attributes) { attributes_for(:collection).merge(name: "") }

      it "renders 'edit' template" do
        expect(controller).to redirect_to(edit_admin_group_path)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:collection) { create(:collection) }

    before do
      delete :destroy, id: collection.id
    end

    it "renders 'index' template" do
      expect(controller).to redirect_to(edit_admin_group_path)
    end
  end
end
