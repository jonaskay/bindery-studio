require 'rails_helper'

RSpec.describe Authenticator, type: :model do
  describe ".access_token" do
    subject { described_class.access_token(authorization) }

    context "when authorization header contains a bearer token" do
      let(:authorization) { "Bearer foo" }

      it { is_expected.to eq("foo") }
    end

    context "when authorization header doesn't contain a bearer prefix" do
      let(:authorization) { "foo" }

      it "raises an error" do
        expect { subject }.to raise_error(Authenticator::Error,
                                          "Bearer token is invalid")
      end
    end

    context "when authorization header doesn't contain a token" do
      let(:authorization) { "Bearer " }

      it "raises an error" do
        expect { subject }.to raise_error(Authenticator::Error,
                                          "Bearer token is invalid")
      end
    end
  end

  describe ".validate_token" do
    let(:validator) { instance_double("GoogleIDToken::Validator") }

    before do
      allow(validator).to receive(:check).with("foo", "TODO")
                                         .and_return({ foo: "bar" })
      allow(validator).to receive(:check).with("invalid", "TODO")
                                         .and_raise(GoogleIDToken::ValidationError)
    end

    subject { described_class.validate_token(access_token, validator) }

    context "when token is valid" do
      let(:access_token) { "foo" }

      it { is_expected.to be true }
    end

    context "when token is invalid" do
      let(:access_token) { "invalid" }

      it { is_expected.to be false }
    end
  end
end
