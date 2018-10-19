require 'spec_helper'

describe RestroomsController, type: :controller do
  it "should get index" do
    get :index
    expect(response).to be_success
  end

  context "voting" do
    let(:restroom) { FactoryBot.create(:restroom) }
    let(:post_params_downvote) {
      {
        id: restroom.id,
        restroom: {
          downvote: true
        }
      }
    }
    let(:post_params_upvote) {
      {
        id: restroom.id,
        restroom: {
          upvote: true
        }
      }
    }

    it "should downvote" do
      expect {
        post :update, params: post_params_downvote
      }.to change { restroom.reload.downvote }.by 1
    end

    it "should upvote" do
      expect {
        post :update, params: post_params_upvote
      }.to change { restroom.reload.upvote }.by 1
    end

    it "shouldn't upvote or downvote twice" do
      session[:voted_for] = [restroom.id]

      expect {
        post :update, params: post_params_upvote
      }.not_to change { restroom.reload.upvote }

      expect {
        post :update, params: post_params_downvote
      }.not_to change { restroom.reload.downvote }
    end

    it "should allow you to vote for multiple restrooms" do
      restroom_two = FactoryBot.create(:restroom)
      session[:voted_for] = [restroom.id]

      post_params = {
        id: restroom_two.id,
        restroom: {
          downvote: true
        }
      }

      expect {
        post :update, params: post_params
      }.to change { restroom_two.reload.downvote }.by 1
    end
  end
end
