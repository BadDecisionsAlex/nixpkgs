{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "stripe-cli";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "stripe";
    repo = pname;
    rev = "v${version}";
    sha256 = "1gb9xk40drj7z6sw6a2hva4kvim508q4f3cfjpmr7yjzspqy32p0";
  };

  vendorSha256 = "05cyn9cgmijj6dl075slwm5qc6fj6m5sm414wqm50xz2fjs0400r";

  subPackages = [
    "cmd/stripe"
  ];

  meta = with stdenv.lib; {
    homepage = "https://stripe.com/docs/stripe-cli";
    description = "A command-line tool for Stripe";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ RaghavSood ];
  };
}
