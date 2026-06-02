// src/main/java/com/economiangola/repository/ConquistaRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.Conquista;
import com.economiangola.domain.enums.CriterioTipo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ConquistaRepository extends JpaRepository<Conquista, Long> {

    List<Conquista> findByCriterioTipo(CriterioTipo criterioTipo);
}
