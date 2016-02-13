require 'spec_helper'

describe ImageComparator do
	let(:first_path) { fixtures + "a.png" }
	let(:second_path) { fixtures + "darker.png" }
	let(:difference_path) { __dir__ + "/tmp/difference.png" }

	subject { ImageComparator.compare(first_path, second_path) }

	it { expect(subject).to be_a ImageComparator::RGB::CompareResult }

	it "saves difference image if need" do
		subject.save_difference_image difference_path
		expect(Pathname.new(difference_path)).to be_exist
	end


	describe 'RGB' do
		context "with similar images" do
			it "score equals to 1" do
				expect(subject.score).to eq 1
			end
		end

		context "with different images" do
			let(:second_path) { fixtures + "b.png"}

			it "score equals to 0.971224" do
				expect(subject.score).to eq 0.971224
			end

			it "saves correct difference image" do
				subject.save_difference_image difference_path
				expect(File.read(difference_path)).to eq(File.read(fixtures + "rgb_diff.png"))
			end
		end
	end
end
