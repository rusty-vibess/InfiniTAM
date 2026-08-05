#include "ITMLib/ITMLibDefines.h"
#include "ITMLib/Core/ITMBasicEngine.h"
#include "ITMLib/Engines/Meshing/ITMMeshingEngineFactory.h"
#include "ITMLib/Engines/Meshing/ITMMultiMeshingEngineFactory.h"
#include "ITMLib/Engines/Reconstruction/ITMSceneReconstructionEngineFactory.h"
#include "ITMLib/Engines/Swapping/ITMSwappingEngineFactory.h"
#include "ITMLib/Engines/Visualisation/ITMMultiVisualisationEngineFactory.h"
#include "ITMLib/Engines/Visualisation/ITMVisualisationEngineFactory.h"

static_assert(ITMVoxel::hasColorInformation == static_cast<bool>(INFINITAM_VOXEL_HAS_COLOR),
              "Configured voxel color support does not match the exported package metadata.");

int main()
{
  typedef ITMLib::ITMBasicEngine<ITMVoxel, ITMVoxelIndex> EngineType;
  typedef ITMLib::ITMMeshingEngineFactory MeshingFactory;
  typedef ITMLib::ITMMultiMeshingEngineFactory MultiMeshingFactory;
  typedef ITMLib::ITMSceneReconstructionEngineFactory ReconstructionFactory;
  typedef ITMLib::ITMSwappingEngineFactory SwappingFactory;
  typedef ITMLib::ITMMultiVisualisationEngineFactory MultiVisualisationFactory;
  typedef ITMLib::ITMVisualisationEngineFactory VisualisationFactory;

  void (EngineType::*load)() = &EngineType::LoadFromFile;
  void (EngineType::*save)() = &EngineType::SaveToFile;

  return (load == 0 || save == 0 ||
          sizeof(MeshingFactory) == 0 ||
          sizeof(MultiMeshingFactory) == 0 ||
          sizeof(ReconstructionFactory) == 0 ||
          sizeof(SwappingFactory) == 0 ||
          sizeof(MultiVisualisationFactory) == 0 ||
          sizeof(VisualisationFactory) == 0) ? 1 : 0;
}
