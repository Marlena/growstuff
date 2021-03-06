require 'rails_helper'

describe OrdersController do

  login_member(:admin_member)

  def valid_attributes
    { "member_id" => 1 }
  end

  def valid_session
    {}
  end

  describe "GET checkout" do
    it 'sets the referral_code' do
      member = FactoryGirl.create(:member)
      sign_in member
      order = Order.create!(:member_id => member.id)
      get :checkout, {:id => order.to_param, :referral_code => 'FOOBAR'}
      order.reload
      order.referral_code.should eq 'FOOBAR'
    end

    it "redirects to Paypal" do
      member = FactoryGirl.create(:member)
      sign_in member
      order = Order.create!(:member_id => member.id)
      get :checkout, {:id => order.to_param}
      response.status.should eq 302
      response.redirect_url.should match /paypal\.com/
    end
  end

  describe "GET complete" do
    it "assigns the requested order as @order" do
      member = FactoryGirl.create(:member)
      sign_in member
      order = Order.create!(:member_id => member.id)
      get :complete, {:id => order.to_param}
      assigns(:order).should eq(order)
    end
  end

  describe "DELETE destroy" do
    it "redirects to the shop" do
      member = FactoryGirl.create(:member)
      sign_in member
      order = Order.create!(:member_id => member.id)
      delete :destroy, {:id => order.id}
      response.should redirect_to(shop_url)
    end
  end

end
