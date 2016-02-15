require 'spec_helper'

describe ImageComparator do
  let(:first_path) { fixtures + "a.png" }
  let(:second_path) { fixtures + "darker.png" }
  let(:difference_path) { root + "/tmp/spec/difference.png" }

  subject { ImageComparator.compare(first_path, second_path) }

  it { expect(subject).to be_a ImageComparator::RGB::CompareResult }

  it "saves difference image if need" do
    subject.save_difference_image difference_path
    expect(Pathname.new(difference_path)).to be_exist
  end

  context "when sizes mismatch" do
    let(:second_path) { fixtures + 'small.png' }

    it "raises SizesMismatchError" do
      expect{ subject }.to raise_error(SizesMismatchError)
    end
  end

  context "when try to use undefined mode" do
    subject { ImageComparator.compare(first_path, second_path, :undefined_mode) }

    it "raises ArgumentError" do
      expect{ subject }.to raise_error(ArgumentError)
    end
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

  describe 'Delta' do
    subject { ImageComparator.compare(first_path, second_path, :delta) }

    context "with similar images" do
      it "score equals to 0.09413561679173654" do
        expect(subject.score).to eq 0.09413561679173654
      end
    end

    context "with different images" do
      let(:second_path) { fixtures + "b.png"}

      it "score equals to 0.019625652485167986" do
        expect(subject.score).to eq 0.019625652485167986
      end

      it "saves correct difference image" do
        subject.save_difference_image difference_path
        expect(File.read(difference_path)).to eq(File.read(fixtures + "delta_diff.png"))
      end
    end 
  end

  describe 'Grayscale' do
    subject { ImageComparator.compare(first_path, second_path, :grayscale) }

    context "with similar images" do
      it "score equals to 0.765716" do
        expect(subject.score).to eq 0.765716
      end
    end

    context "with different images" do
      let(:second_path) { fixtures + "b.png"}

      it "score equals to 0.009328" do
        expect(subject.score).to eq 0.009328
      end

      it "saves correct difference image" do
        subject.save_difference_image difference_path
        expect(File.read(difference_path)).to eq(File.read(fixtures + "grayscale_diff.png"))
      end
    end
  end
end
