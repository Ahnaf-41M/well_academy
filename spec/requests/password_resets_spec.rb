require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  describe "GET /password_resets/new" do
    it "returns http success" do
      get new_password_reset_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /password_resets" do
    context "when the email belongs to an existing user" do
      let!(:user) { create(:user) }

      it "generates a reset token and redirects to the root path" do
        post password_resets_path, params: { email: user.email }

        expect(user.reload.reset_password_token).to be_present
        expect(response).to redirect_to(root_path)
      end
    end

    context "when the email does not match any user" do
      it "re-renders the new template with an unprocessable status" do
        post password_resets_path, params: { email: "nobody@example.com" }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /password_resets/:reset_password_token/edit" do
    let(:user) { create(:user) }

    context "with a valid, unexpired token" do
      before { user.generate_password_reset_token! }

      it "returns http success" do
        get edit_password_reset_path(reset_password_token: user.reset_password_token)
        expect(response).to have_http_status(:success)
      end
    end

    context "with an expired token" do
      before do
        user.generate_password_reset_token!
        user.update_column(:reset_password_sent_at, 3.hours.ago)
      end

      it "redirects to the new password reset page" do
        get edit_password_reset_path(reset_password_token: user.reset_password_token)
        expect(response).to redirect_to(new_password_reset_path)
      end
    end
  end

  describe "PATCH /password_resets/:reset_password_token" do
    let(:user) { create(:user) }

    before { user.generate_password_reset_token! }

    context "with a matching password confirmation" do
      it "updates the password, clears the token and redirects to login" do
        patch password_reset_path(reset_password_token: user.reset_password_token), params: {
          user: { password: "newpassword", password_confirmation: "newpassword" }
        }

        expect(response).to redirect_to(login_sessions_path)
        user.reload
        expect(user.reset_password_token).to be_nil
        expect(user.authenticate("newpassword")).to eq(user)
      end
    end

    context "with a mismatched password confirmation" do
      it "re-renders the edit template with an unprocessable status" do
        patch password_reset_path(reset_password_token: user.reset_password_token), params: {
          user: { password: "newpassword", password_confirmation: "mismatch" }
        }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
