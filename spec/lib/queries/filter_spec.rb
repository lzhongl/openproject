#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2013 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

require 'spec_helper'

describe Queries::WorkPackages::Filter do
  describe :type do

    describe 'validations' do
      subject { filter }

      let(:filter) { FactoryGirl.build :filter }

      context 'when it is of type integer' do
        before { filter.field = 'done_ratio' }

        context 'and the filter values is an integer' do
          before { filter.values = [1, '12', 123] }
          it { should be_valid }
        end

        context 'and the filter values is not an integer' do
          before { filter.values == [1, 'asdf'] }
          it { should_not be_valid }
        end
      end

      context 'when the operator does not require values' do
        let(:filter) { FactoryGirl.build :filter, field: :status_id, operator: '*', values: [] }

        it 'is valid if no values are given' do
          filter.should be_valid
        end
      end

      context 'when the operator requires values' do
        let(:filter) { FactoryGirl.build :filter, field: :done_ratio, operator: '>=', values: [] }

        context 'and no value is given' do
          it { should_not be_valid }
        end

        context 'and values are given' do
          before { filter.values = [5] }

          it { should be_valid }
        end
      end

      context 'when it is a work package filter' do
        let(:filter) { FactoryGirl.build :work_packages_filter }

        context 'and the field is whitelisted' do
          before { filter.field = :project_id }

          it { should be_valid }
        end

        context 'and the field is not whitelisted and no custom field key' do
          before { filter.field = :any_key }

          it { should_not be_valid }
        end

        context 'and the field is a custom field starting with "cf"' do
          before { filter.field = :cf_any_key }

          it { should be_valid }
        end
      end
    end
  end
end
