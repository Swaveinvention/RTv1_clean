/////////////////////////////////////////////////////////////
// Cineware SDK                                            //
/////////////////////////////////////////////////////////////
// (c) MAXON Computer GmbH, all rights reserved            //
/////////////////////////////////////////////////////////////

#ifndef C4D_VOLUMEBUILDERDATA_H__
#define C4D_VOLUMEBUILDERDATA_H__

#include "c4d_nodedata.h"
#include "c4d_rootobject.h"

namespace cineware
{
#pragma pack (push, 8)

class BaseDocument;

//----------------------------------------------------------------------------------------
/// Node data class for @C4D's Volume Builder object.
/// @since R20
//----------------------------------------------------------------------------------------
class VolumeBuilderData : public NodeData
{
	INSTANCEOF(VolumeBuilderData, NodeData)

	friend class BaseObject;

public:

protected:
	static NodeData* Alloc();

private:
	virtual Bool Init();
	virtual void Free();

	virtual Bool SetDParameter(const DescID& id, const GeData& t_data);
	virtual Bool GetDParameter(const DescID& id, GeData& t_data);

	virtual Int32 GetChunkLevel();

	virtual Bool Read(HyperFile* hf, Int32 id, Int32 level);
	virtual Bool Write(HyperFile* hf);
	virtual Bool CopyToX(PrivateChunk* dest, COPYFLAGS flags, AliasTrans* trn);

	RootObject* _filter_head; // GeListHead
};

#pragma pack (pop)
}

#endif	// C4D_VOLUMEBUILDERDATA_H__