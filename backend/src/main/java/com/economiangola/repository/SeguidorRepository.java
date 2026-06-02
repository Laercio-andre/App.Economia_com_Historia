// src/main/java/com/economiangola/repository/SeguidorRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.Seguidor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface SeguidorRepository extends JpaRepository<Seguidor, Long> {

    Optional<Seguidor> findBySeguidorIdAndSeguidoId(Long seguidorId, Long seguidoId);

    boolean existsBySeguidorIdAndSeguidoId(Long seguidorId, Long seguidoId);

    long countBySeguidoId(Long seguidoId);

    long countBySeguidorId(Long seguidorId);
}
