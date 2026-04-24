#include "ITMLib/ITMLibDefines.h"
#include "ITMLib/Core/ITMBasicEngine.h"

int main()
{
  typedef ITMLib::ITMBasicEngine<ITMVoxel, ITMVoxelIndex> EngineType;

  void (EngineType::*load)() = &EngineType::LoadFromFile;
  void (EngineType::*save)() = &EngineType::SaveToFile;

  return (load == 0 || save == 0) ? 1 : 0;
}
