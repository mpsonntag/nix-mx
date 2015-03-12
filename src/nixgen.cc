#include "nixgen.h"

#include "mex.h"

#include <nix.hpp>

#include "handle.h"
#include "arguments.h"
#include "struct.h"

namespace nixgen {

mxArray *dataset_read_all(const nix::DataSet &da) {
    nix::NDSize size = da.dataExtent();
    const size_t len = size.size();
    std::vector<mwSize> dims(len);

    //NB: matlab is column-major, while HDF5 is row-major
    //    data is correct with this, but dimensions don't
    //    agree with the file anymore. Transpose it in matlab
    //    (DataArray.read_all)
    for (size_t i = 0; i < len; i++) {
        dims[len - (i + 1)] = static_cast<mwSize>(size[i]);
    }

    nix::DataType da_type = da.dataType();
    DType2 dtype = dtype_nix2mex(da_type);

    if (!dtype.is_valid) {
        throw std::domain_error("Unsupported data type");
    }

    mxArray *data = mxCreateNumericArray(dims.size(), dims.data(), dtype.cid, dtype.clx);
    double *ptr = mxGetPr(data);

    nix::NDSize offset(size.size(), 0);
    da.getData(da_type, ptr, size, offset);

    return data;
}

nix::LinkType get_link_type(uint8_t ltype)
{
    nix::LinkType link_type;

    switch (ltype) {
    case 0: link_type = nix::LinkType::Tagged; break;
    case 1: link_type = nix::LinkType::Untagged; break;
    case 2: link_type = nix::LinkType::Indexed; break;
    default: throw std::invalid_argument("unkown link type");
    }

    return link_type;
}

} // namespace nixgen
